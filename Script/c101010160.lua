--
function c101010160.initial_effect(c)
local ss=Effect.CreateEffect(c)
	ss:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	ss:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	ss:SetCode(EVENT_REMOVE)
	ss:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	ss:SetLabel(0)
	ss:SetCondition(c101010160.con)
	ss:SetTarget(c101010160.target)
	ss:SetOperation(c101010160.op)
	c:RegisterEffect(ss)
end
function c101010160.filter(c,e,tp)
	return c:IsSetCard(0x785e) and c:GetCode()~=101010160 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010160.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=1
	if c:IsPreviousLocation(LOCATION_GRAVE) then
		e:SetLabel(1)
	elseif c:IsPreviousLocation(LOCATION_DECK+LOCATION_HAND) then
		if c:IsPreviousLocation(LOCATION_HAND) then ct=2 end
		e:SetLabel(2)
	end
	local res=c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if c:IsPreviousLocation(LOCATION_DECK+LOCATION_HAND) then res=Duel.IsExistingTarget(c101010160.filter,tp,LOCATION_REMOVED,0,ct,nil,e,tp) or c:IsAbleToGrave() end
	return e:GetLabel()~=0 and res
end
function c101010160.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc and e:GetLabel()==2 then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c101010160.filter(chkc,e,tp) end
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=c
	local ct=1
	local cc=e:GetLabel()
	if cc==2 then
		local sg=Duel.GetMatchingGroup(c101010160.filter,tp,LOCATION_REMOVED,0,nil,e,tp)
		if g:IsPreviousLocation(LOCATION_HAND) then ct=2 end
		g=sg:Select(tp,ct,ct,nil)
		Duel.SetTargetCard(g)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,ct,nil,nil)
end
function c101010160.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cc=e:GetLabel()
	local tc=c
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g~=nil then
		local tg=g:Filter(Card.IsRelateToEffect,nil,e)
		local check=false
		if cc==2 then
			Duel.SendtoGrave(tc,REASON_EFFECT)
			if tg:GetCount()==0 then return end
			check=true
			tc=tg:GetFirst()
		end
	end
	while tc do
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		if check then tc=tg:GetNext() else break end
	end
end
