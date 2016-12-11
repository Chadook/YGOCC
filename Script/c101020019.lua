--created by LionHeartKIng
--coded by Lyris
--Necromaster of Stellar Vine
function c101020019.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(46659709,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101020019)
	e1:SetTarget(c101020019.sptg)
	e1:SetOperation(c101020019.spop)
	c:RegisterEffect(e1)
	--call
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,201010604)
	e2:SetTarget(c101020019.target)
	e2:SetOperation(c101020019.operation)
	c:RegisterEffect(e2)
end
function c101020019.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x785e) and not c:IsCode(101020019)
end
function c101020019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c101020019.cfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c101020019.cfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101020019.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.SendtoGrave(tc,REASON_EFFECT) and e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101020019.filter(c,e,tp)
	return c:IsSetCard(0x785e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetCode()~=101020019
end
function c101020019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc==c end
	if chk==0 then return c:IsAbleToGrave() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101020019.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetTargetCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101020019.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101020019.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetDescription(1124)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_PHASE+PHASE_END)
		e0:SetCountLimit(1)
		e0:SetRange(LOCATION_MZONE)
		e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) Duel.Destroy(e:GetHandler(),REASON_EFFECT) end)
		tc:RegisterEffect(e0,true)
	end
end
