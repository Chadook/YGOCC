--Carefree Itchy
function c83030021.initial_effect(c)
	--Special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(83030021,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c83030021.spcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--lose atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(83030008,0))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,83030021)
	e2:SetTarget(c83030021.tg)
	e2:SetOperation(c83030021.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--Special summon, return to deck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(83030008,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c83030021.condition)
	e5:SetTarget(c83030021.target)
	e5:SetOperation(c83030021.operation)
	c:RegisterEffect(e5)
	--Negate own effects
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetOperation(c83030021.spop)
	c:RegisterEffect(e6)
end
function c83030021.spcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x833) and c:GetCode()~=83030021
end
function c83030021.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c83030021.spcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c83030021.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSummonType()==SUMMON_TYPE_SPECIAL+1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c83030021.cfilter(c)
	return c:IsFaceup() and c:IsCode(83030019)
end
function c83030021.filter(c)
	return c:IsFaceup() and not c:IsSetCard(0x833)
end
function c83030021.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c83030021.op(e,tp,eg,ep,ev,re,r,rp)
	local p,val=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,val,REASON_EFFECT)
	local dg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local edg=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	if Duel.IsExistingMatchingCard(c83030021.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
		and (dg:GetCount()>0 or edg:GetCount()>0) and Duel.SelectYesNo(1-tp,aux.Stringid(83030021,2)) then
		local op=0
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(76922029,0))
		if dg:GetCount()>0 and edg:GetCount()>0 then
			op=Duel.SelectOption(1-tp,aux.Stringid(83030021,3),aux.Stringid(83030021,4))
		elseif dg:GetCount()>0 then
			Duel.SelectOption(1-tp,aux.Stringid(83030021,3))
			op=0
		else
			Duel.SelectOption(1-tp,aux.Stringid(83030021,4))
			op=1
		end
		if op==0 then
			Duel.ConfirmCards(1-tp,dg)
			Duel.ShuffleDeck(tp)
		else
			Duel.ConfirmCards(1-tp,edg)
		end
	end
end
function c83030021.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN)
end
function c83030021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c83030021.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e1,true)
	end
end
