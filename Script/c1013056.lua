--Graveyard of Lost Souls
function c1013056.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c1013056.act)
	c:RegisterEffect(e1)
	--Indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetCondition(c1013056.descon)
	e2:SetValue(c1013056.valcon)
	c:RegisterEffect(e2)
	--Add to Hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1013056,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c1013056.condition)
	e3:SetTarget(c1013056.target)
	e3:SetOperation(c1013056.operation)
	c:RegisterEffect(e3)
	--Draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1013056,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c1013056.drcon)
	e4:SetTarget(c1013056.drtg)
	e4:SetOperation(c1013056.drop)
	c:RegisterEffect(e4)
	--Destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1013056,2))
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c1013056.sncon)
	e5:SetTarget(c1013056.sntg)
	e5:SetOperation(c1013056.snop)
	c:RegisterEffect(e5)
end
function c1013056.act(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsRace,tp,0x21,0,nil,RACE_ZOMBIE)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c1013056.descon(e)
	return Duel.IsExistingMatchingCard(Card.IsRace,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,RACE_ZOMBIE)
end
function c1013056.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c1013056.condition(e,tp,eg,ep,ev,re,r,rp)
	local lv=0
	local g=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_GRAVE,0,nil,RACE_ZOMBIE)
	local tc=g:GetFirst()
	while tc do
		if tc:GetLevel()>0 and not tc:IsLocation(LOCATION_SZONE) then
			local tlv=tc:GetLevel()
			if tlv>0 then lv=lv+tlv end
		end
		tc=g:GetNext()
	end
	if lv>12 then lv=12 end
	if lv>0 then e:SetLabel(lv) end
	return lv>0 and Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,1,nil,RACE_ZOMBIE)
end
function c1013056.gfilter(c,lv)
	return c:IsRace(RACE_ZOMBIE) and c:IsLevelBelow(lv) and c:IsAbleToHand()
end
function c1013056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1013056.gfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c1013056.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectMatchingCard(tp,c1013056.gfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1013056.drcfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_MZONE) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ZOMBIE) 
		and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp
end
function c1013056.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1013056.drcfilter,1,nil,tp)
end
function c1013056.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c1013056.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c1013056.sncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
		and (not re or re:GetHandler()~=c)
end
function c1013056.sfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsDestructable()
end
function c1013056.sntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c1013056.sfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c1013056.snop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1013056.sfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end